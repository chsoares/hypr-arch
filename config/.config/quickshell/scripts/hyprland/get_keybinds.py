#!/usr/bin/env -S\_/bin/sh\_-c\_"source\_\$(eval\_echo\_\$ILLOGICAL_IMPULSE_VIRTUAL_ENV)/bin/activate&&exec\_python\_-E\_"\$0"\_"\$@""
import argparse
import re
import os
from os.path import expandvars as os_expandvars

TITLE_REGEX = r"[#\-]+!"
HIDE_COMMENT = "[hidden]"
MOD_SEPARATORS = ['+', ' ']
COMMENT_BIND_PATTERN = "#/#"
LUA_COMMENT_BIND_PATTERN = "--#/#"

parser = argparse.ArgumentParser(description='Hyprland keybind reader')
parser.add_argument('--path', type=str, default="$HOME/.config/hypr/hyprland.conf", help='path to keybind file')
args = parser.parse_args()

Variables = {}


class KeyBinding(dict):
    def __init__(self, mods, key, dispatcher, params, comment) -> None:
        self["mods"] = mods
        self["key"] = key
        self["dispatcher"] = dispatcher
        self["params"] = params
        self["comment"] = comment


class Section(dict):
    def __init__(self, children, keybinds, name) -> None:
        self["children"] = children
        self["keybinds"] = keybinds
        self["name"] = name


def read_content(path: str) -> str:
    expanded = os.path.expanduser(os.path.expandvars(path))
    if not os.access(expanded, os.R_OK):
        return "error"
    with open(expanded, "r") as file:
        return file.read()


def is_lua_file(path: str) -> bool:
    return path.endswith('.lua')


def autogenerate_comment(dispatcher: str, params: str = "") -> str:
    match dispatcher:
        case "resizewindow" | "resize":
            return "Resize window"
        case "movewindow" | "drag":
            if params == "":
                return "Move window"
            else:
                return "Window: move in {} direction".format({
                    "l": "left", "r": "right", "u": "up", "d": "down",
                }.get(params, "null"))
        case "pin":
            return "Window: pin (show on all workspaces)"
        case "splitratio":
            return "Window split ratio {}".format(params)
        case "togglefloating" | "float":
            return "Float/unfloat window"
        case "resizeactive":
            return "Resize window by {}".format(params)
        case "killactive" | "close":
            return "Close window"
        case "fullscreen":
            return "Toggle {}".format({
                "0": "fullscreen", "1": "maximization",
                "2": "fullscreen on Hyprland's side",
            }.get(params, "null"))
        case "fakefullscreen":
            return "Toggle fake fullscreen"
        case "workspace":
            if params == "+1": return "Workspace: focus right"
            elif params == "-1": return "Workspace: focus left"
            elif params == "previous": return "Focus previous workspace"
            return "Focus workspace {}".format(params)
        case "movefocus" | "focus":
            return "Window: move focus {}".format({
                "l": "left", "r": "right", "u": "up", "d": "down",
            }.get(params, "null"))
        case "swapwindow":
            return "Window: swap in {} direction".format({
                "l": "left", "r": "right", "u": "up", "d": "down",
            }.get(params, "null"))
        case "movetoworkspace":
            if params == "+1": return "Window: move to right workspace (non-silent)"
            elif params == "-1": return "Window: move to left workspace (non-silent)"
            return "Window: move to workspace {} (non-silent)".format(params)
        case "movetoworkspacesilent":
            if params == "+1": return "Window: move to right workspace"
            elif params == "-1": return "Window: move to left workspace"
            return "Window: move to workspace {}".format(params)
        case "togglespecialworkspace":
            return "Workspace: toggle special"
        case "exec":
            return "Execute: {}".format(params)
        case _:
            return ""


LUA_DISPATCHER_MAP = {
    "window.drag":        ("movewindow", ""),
    "window.resize":      ("resizewindow", ""),
    "window.close":       ("killactive", ""),
    "window.float":       ("togglefloating", ""),
    "window.pin":         ("pin", ""),
    "window.fullscreen":  ("fullscreen", ""),
    "window.fullscreen_state": ("fullscreenstate", ""),
    "window.move":        ("movewindow", ""),
    "workspace.toggle_special": ("togglespecialworkspace", ""),
    "layout":             ("layoutmsg", ""),
    "global":             ("global", ""),
    "exec_cmd":           ("exec", ""),
}


def parse_lua_bind_args(dispatcher_str, args_str):
    """Extract dispatcher name and meaningful params from Lua hl.dsp call."""
    dispatcher = dispatcher_str.strip()
    params = ""
    args = args_str.strip()

    if dispatcher == "window.drag":
        return ("movewindow", "")
    elif dispatcher == "window.resize":
        return ("resizewindow", "")
    elif dispatcher == "window.close":
        return ("killactive", "")
    elif dispatcher == "window.pin":
        return ("pin", "")
    elif dispatcher == "window.float":
        return ("togglefloating", "")
    elif dispatcher == "workspace.toggle_special":
        return ("togglespecialworkspace", params)
    elif dispatcher == "layout":
        m = re.search(r'"([^"]*)"', args)
        if m:
            return ("layoutmsg", m.group(1))
        return ("layoutmsg", "")
    elif dispatcher == "global":
        m = re.search(r'"([^"]*)"', args)
        if m:
            return ("global", m.group(1))
        return ("global", "")
    elif dispatcher == "exec_cmd":
        m = re.search(r'"([^"]*)"', args)
        if m:
            return ("exec", m.group(1))
        return ("exec", "")
    elif dispatcher == "window.fullscreen":
        m_mode = re.search(r'mode\s*=\s*"(maximized|fullscreen)"', args)
        m_toggle = re.search(r'action\s*=\s*"toggle"', args)
        mode = m_mode.group(1) if m_mode else "0"
        param = "1" if mode == "maximized" else "0"
        return ("fullscreen", param)
    elif dispatcher == "window.fullscreen_state":
        return ("fullscreenstate", "0 3")
    elif dispatcher == "window.move":
        m_dir = re.search(r'direction\s*=\s*"(l|r|u|d)"', args)
        m_ws = re.search(r'workspace\s*=\s*"([^"]+)"', args)
        m_follow = re.search(r'follow\s*=\s*(true|false)', args)
        if m_dir:
            return ("movewindow", m_dir.group(1))
        elif m_ws:
            follow = m_follow.group(1) if m_follow else "true"
            if follow == "false":
                return ("movetoworkspacesilent", m_ws.group(1))
            else:
                return ("movetoworkspace", m_ws.group(1))
        return ("movewindow", "")
    elif dispatcher == "focus":
        m_dir = re.search(r'direction\s*=\s*"(l|r|u|d)"', args)
        m_ws = re.search(r'workspace\s*=\s*"([^"]+)"', args)
        m_action = re.search(r'action\s*=\s*"(bring_to_top)"', args)
        if m_dir:
            return ("movefocus", m_dir.group(1))
        elif m_ws:
            return ("workspace", m_ws.group(1))
        elif m_action:
            return ("bringactivetotop", "")
        return ("focus", "")
    elif dispatcher == "workspace.focus_previous":
        return ("workspace", "previous")
    elif dispatcher == "workspace.cycle_next":
        return ("cyclenext", "")

    return (dispatcher, params)


def parse_lua_bind_key(key_str):
    """Parse 'SUPER + Q' or 'CTRL + SUPER + Left' into (mods_list, key)."""
    parts = [p.strip() for p in re.split(r'[+ ]', key_str) if p.strip()]
    if len(parts) <= 1:
        return ([], key_str.strip())
    key = parts[-1]
    mods = parts[:-1]
    return (mods, key)


def extract_lua_description(flags_str):
    """Extract description from '{ description = "text", ... }'"""
    m = re.search(r'description\s*=\s*"([^"]*)"', flags_str)
    return m.group(1) if m else None


def parse_lua_keybinds(content):
    """Parse Lua keybinds content and return a Section tree."""
    lines = content.splitlines()
    result = Section([], [], "")
    current_section = result
    section_stack = [(result, 0)]

    i = 0
    while i < len(lines):
        line = lines[i]

        # Heading detection: --! or --!! or --!!!
        heading_match = re.match(TITLE_REGEX, line.lstrip())
        if heading_match:
            scope = line.lstrip().index('!')
            section_name = line[heading_match.end():].strip()

            # Pop back to appropriate level
            while section_stack and section_stack[-1][1] >= scope:
                section_stack.pop()
            parent = section_stack[-1][0] if section_stack else result

            new_section = Section([], [], section_name)
            parent["children"].append(new_section)
            section_stack.append((new_section, scope))
            current_section = new_section
            i += 1
            continue

        # Comment bind pattern --#/#
        if line.lstrip().startswith(LUA_COMMENT_BIND_PATTERN):
            stripped = line.lstrip()[len(LUA_COMMENT_BIND_PATTERN):].strip()
            if stripped:
                current_section["keybinds"].append(
                    KeyBinding([], "", "", "", stripped))
            i += 1
            continue

        # hl.bind detection (single or multi-line)
        stripped = line.lstrip()
        if stripped.startswith("hl.bind(") or stripped.startswith("--hl.bind("):
            # Skip commented-out binds
            if stripped.startswith("--"):
                i += 1
                continue

            bind_text = stripped

            # Collect multi-line bind
            paren_depth = bind_text.count("(") - bind_text.count(")")
            while paren_depth > 0 and i + 1 < len(lines):
                i += 1
                next_line = lines[i].strip()
                if next_line.startswith("--"):
                    continue
                bind_text += " " + next_line
                paren_depth = bind_text.count("(") - bind_text.count(")")

            if paren_depth != 0:
                i += 1
                continue

            # Parse: hl.bind("KEYS", <body>, {flags})
            m = re.match(
                r'hl\.bind\(\s*"([^"]+)"\s*,\s*(.+?)\s*\)\s*$',
                bind_text, re.DOTALL)

            if not m:
                i += 1
                continue

            key_str = m.group(1)
            body = m.group(2)

            # Split body into dispatcher part and flags part
            # Body can be: hl.dsp.X(args), {flags}
            # Or: function() ... end, {flags}
            # Or: hl.dsp.X(args)  (no flags = hidden)

            flags = ""
            # Find the flags table { ... } at the end
            flags_match = re.search(r',\s*(\{(?:[^{}]|\{[^{}]*\})*\})\s*$', body)
            if flags_match:
                flags = flags_match.group(1)
                body = body[:flags_match.start()]

            # Check if hidden or has description
            description = extract_lua_description(flags) if flags else None
            if description is None:
                i += 1
                continue

            # Parse dispatcher
            body = body.strip()
            old_dispatcher = "exec"
            old_params = ""

            # hl.dsp.X(...) pattern
            dsp_match = re.match(r'hl\.dsp\.(\S+?)\s*\((.*)\)\s*$', body, re.DOTALL)
            if dsp_match:
                old_dispatcher, old_params = parse_lua_bind_args(
                    dsp_match.group(1), dsp_match.group(2))
            elif body.startswith("function"):
                old_dispatcher = "exec"
                old_params = "(lua function)"
            else:
                # Bare function or variable reference
                old_dispatcher = "exec"
                old_params = body.strip().strip('"')

            mods, key = parse_lua_bind_key(key_str)
            current_section["keybinds"].append(
                KeyBinding(mods, key, old_dispatcher, old_params, description))

        i += 1

    return result


def get_keybind_at_line(line_number, line_start=0):
    global content_lines
    line = content_lines[line_number]
    if line_start:
        line = line[line_start:]
    _, keys = line.split("=", 1)
    keys, *comment = keys.split("#", 1)
    mods, key, dispatcher, *params = list(map(str.strip, keys.split(",", 4)))
    params = "".join(map(str.strip, params))
    comment = list(map(str.strip, comment))
    if comment:
        comment = comment[0]
        if comment.startswith("[hidden]"):
            return None
    else:
        comment = autogenerate_comment(dispatcher, params)
    if mods:
        modstring = mods + MOD_SEPARATORS[0]
        mods = []
        p = 0
        for index, char in enumerate(modstring):
            if char in MOD_SEPARATORS:
                if index - p > 1:
                    mods.append(modstring[p:index])
                p = index + 1
    else:
        mods = []
    return KeyBinding(mods, key, dispatcher, params, comment)


def get_binds_recursive(current_content, scope):
    global content_lines, reading_line
    while reading_line < len(content_lines):
        line = content_lines[reading_line]
        heading_search_result = re.search(TITLE_REGEX, line)
        if heading_search_result is not None and heading_search_result.start() == 0:
            heading_scope = line.find('!')
            if heading_scope <= scope:
                reading_line -= 1
                return current_content
            section_name = line[(heading_scope + 1):].strip()
            reading_line += 1
            current_content["children"].append(
                get_binds_recursive(Section([], [], section_name), heading_scope))
        elif line.startswith(COMMENT_BIND_PATTERN):
            keybind = get_keybind_at_line(
                reading_line, line_start=len(COMMENT_BIND_PATTERN))
            if keybind is not None:
                current_content["keybinds"].append(keybind)
        elif line == "" or not line.lstrip().startswith("bind"):
            pass
        else:
            keybind = get_keybind_at_line(reading_line)
            if keybind is not None:
                current_content["keybinds"].append(keybind)
        reading_line += 1
    return current_content


def parse_conf_content(content):
    """Parse .conf format keybinds."""
    global content_lines, reading_line
    content_lines = content.splitlines()
    reading_line = 0
    return get_binds_recursive(Section([], [], ""), 0)


def parse_keys(path: str):
    content = read_content(path)
    if content == "error":
        return "error"

    if is_lua_file(path):
        return parse_lua_keybinds(content)
    else:
        return parse_conf_content(content)


if __name__ == "__main__":
    import json
    ParsedKeys = parse_keys(args.path)
    print(json.dumps(ParsedKeys))
