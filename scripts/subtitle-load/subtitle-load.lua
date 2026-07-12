local mp = require "mp"
local utils = require "mp.utils"
local msg = require "mp.msg"
local opts = require "mp.options"

local EXTENSION_PATTERN = "%.[^.]+$"

local function get_basename(filename)
  local basename = filename:gsub(EXTENSION_PATTERN, "")
  return basename
end

-- Get the current video's information
local function get_video_info()
  local path = mp.get_property("path", "")
  local dir, filename = utils.split_path(path)

  local basename = get_basename(filename)

  return {
    directory = dir,
    basename = basename,
  }
end

local options = {
  subtitle_folders = "Subs"
}

local function is_directory(path)
  local info = utils.file_info(path)

  return info and info.is_dir
end

local function split(str, delimiter)
  local result = {}

  for item in string.gmatch(str, "([^" .. delimiter .. "]+)") do
    table.insert(result, item)
  end

  return result
end

-- Calculate the subtitle directory based on the video information
local function get_subtitle_directory(video)
  local subtitle_folder_list = split(options.subtitle_folders, ",")

  for _,folder in ipairs(subtitle_folder_list) do
    local subtitle_root = utils.join_path(video.directory, folder)
    local subtitle_directory = utils.join_path(subtitle_root, video.basename)

    if is_directory(subtitle_directory) then
      return subtitle_directory
    end 
  end
  return nil
end

-- Scan subtitles
local function scan_subtitles(directory)
  local files = utils.readdir(directory, "files")

  for _, filename in ipairs(files) do
    local subtitle_path = utils.join_path(directory, filename)
    mp.commandv(
      "sub-add",
      subtitle_path
    )
  end
end

-- Whether embedded subtitles exist
local function has_embedded_subtitles()
end

-- Mount subtitles
local function load_external_subtitles(files)
end

local function load_subtitles()
  opts.read_options(options)

  local video = get_video_info()

  local directory = get_subtitle_directory(video)
  msg.info("subtitle directory = " .. tostring(directory))
  if not directory then
      return
  end

  scan_subtitles(directory)
end

mp.register_event("file-loaded", load_subtitles)
