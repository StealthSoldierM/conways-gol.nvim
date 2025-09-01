# :rocket: Quick Start

## For :zzz: Lazy.nvim

```lua
{
    'StealthSoldierM/conways-gol.nvim',
    config = function()
        vim.keymap.set('n', '<leader>cg', ':Conway<CR>', { desc = 'Play conways Game of Life'})
    end,
    lazy = false,
}
```



# :books: Usage Example
ther are Two Ways to Start the  Game
1. Using *neovim's* command mode
```console
$ :Conway
```

2. Using Key Bindings
To start/stop **Conways - Game of Life** type below keys in *neovim* on ~~Normal Mode~~.

```
<leader>cg -> Init+Start the Game
q -> To Quit The Game
p -> Toogle Play and pause State
```

# :sparkles: Summary
Just enjoy
