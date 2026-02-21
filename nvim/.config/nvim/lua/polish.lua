-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't fit in the normal config locations above can go here

-- Performance optimization: set updatetime for faster LSP feedback
vim.opt.updatetime = 250

-- Ensure stylua is used for Lua formatting
vim.g.stylua_formatting = true

-- 快速切换主题功能
local themes = {
	"astrotheme",
	"habamax",
	"dayfox",
	"nightfox",
	"dawnfox",
	"duskfox",
	"nordfox",
	"terafox",
	"carbonfox",
	"catppuccin-latte",
	"catppuccin-frappe",
	"catppuccin-macchiato",
	"catppuccin-mocha",
}
local current = 1

-- 安全应用主题，避免报错中断
local function apply_theme(name)
	local ok, err = pcall(vim.cmd.colorscheme, name)
	if not ok then
		vim.notify("切换主题失败: " .. tostring(err), vim.log.levels.ERROR)
		return false
	end
	vim.notify("已切换主题: " .. name, vim.log.levels.INFO)
	return true
end

-- 轮换到下一个主题
local function switch_theme()
	current = current % #themes + 1
	apply_theme(themes[current])
end

-- 用选择器选择主题
local function pick_theme()
	vim.ui.select(themes, { prompt = "选择主题:" }, function(choice)
		if choice then
			for i, v in ipairs(themes) do
				if v == choice then
					current = i
					break
				end
			end
			apply_theme(choice)
		end
	end)
end

-- 单一主题命令：支持轮换 / 选择器 / 指定（带补全）
vim.api.nvim_create_user_command("Theme", function(opts)
	local name = opts.args

	-- 无参数：普通调用打开选择器，带 ! 时轮换
	if name == "" then
		if opts.bang then
			switch_theme()
		else
			pick_theme()
		end
		return
	end

	-- 记录当前主题索引（如果在列表中）
	for i, v in ipairs(themes) do
		if v == name then
			current = i
			break
		end
	end

	apply_theme(name)
end, {
	nargs = "?",
	bang = true,
	complete = function(ArgLead, _)
		local matches = {}
		for _, theme in ipairs(themes) do
			if theme:find("^" .. vim.pesc(ArgLead)) then
				table.insert(matches, theme)
			end
		end
		return matches
	end,
})
