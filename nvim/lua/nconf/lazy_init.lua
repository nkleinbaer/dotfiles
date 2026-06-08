local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=v11.17.5",
		lazypath,

	})
	end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = "nconf.lazy",
	change_detection = { notify = false }
})
