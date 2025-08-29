# FeMaco

> [!NOTE]
> AcksID's repo uses api of nvim-treesitter which is not compatible if you use `main` branch of nvim-treesitter. \
> This is just reconstruction of `nvim-FeMaco.lua` which use new api of neovim treesitter.

:exclamation: Originally this was written for only markdown code blocks. However this plugin now support any language injection in any language!

Catalyze your **Fe**nced **Ma**rkdown **Co**de-block editing!

![FeMoco_cluster](https://user-images.githubusercontent.com/23341710/182566777-492c5e81-95fc-4443-ae6a-23ba2519960e.png)
(based on [this](https://en.wikipedia.org/wiki/FeMoco#/media/File:FeMoco_cluster.svg))

A small plugin allowing to edit injected language trees with correct filetype in a floating window.
This allows you to use all of your config for your favorite language.
The buffer will be also linked to a temporary file in order to allow LSPs to work properly.

Powered by treesitter, lua and coffee.

https://user-images.githubusercontent.com/23341710/182567238-e1f7bbcc-1f0c-43de-b17d-9d5576aba873.mp4

## Requirements

- `neovim v0.11+`
	- It use native treesitter of neovim v0.11+
- `markdown`, `markdown-inline` treesitter


## Installation
For example using [`lazy.nvim`](https://github.com/folke/lazy.nvim)
```lua
return {
  'Jaehaks/nvim-FeMaco.lua',
  branch = 'development',
  opts = {}
}
```


## Configuration
Pass a configuration table into `require("femaco").setup()` with callback functions. \
These are the defaults:
```lua
require('femaco').setup({
	window = {
		-- if true, opened floating window size will fit the contents with some margin.
		-- if false, floating window opens almost full screen (90% ratio of current window.
		fit_contents = false,
	}
})
```


## Usage
1) Call `require('femaco').edit_code_block()` with your cursor on a code-block.
2) After you finished editing, press `q` to save and close floating window. It will update the original code block.


## Credit
Is is forked from [AckslD/nvim-FeMaco.lua](https://github.com/AckslD/nvim-FeMaco.lua). \
