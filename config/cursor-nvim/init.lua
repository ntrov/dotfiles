-- Cursor-specific Neovim configuration
-- Based on: https://medium.com/@nikmas_dev/vscode-neovim-setup
-- Location: ~/.config/cursor-nvim/init.lua
--
-- Configure Cursor to use this file by setting in settings.json:
--   "vscode-neovim.neovimInitVimPaths.darwin": "~/.config/cursor-nvim/init.lua"

local vscode = require('vscode')

-- ============================================================================
-- Basic Settings 
-- ============================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable features that Cursor handles
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Settings that still apply in VSCode
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.timeoutlen = 300

-- ============================================================================
-- Autocommands
-- ============================================================================

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- ============================================================================
-- Helper function for creating keymaps
-- ============================================================================
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- ============================================================================
-- Basic Keymaps (matching nvim/init.lua lines 79-117)
-- ============================================================================

-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Better escape (matching line 85)
map('i', 'jj', '<Esc>')

-- Exit terminal mode (matching line 96)
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Better indenting (stay in visual mode)
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Keep cursor centered when scrolling
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- Keep cursor centered when searching
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Better paste (don't yank replaced text)
map('v', 'p', '"_dP')

-- Yank to system clipboard
map({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to clipboard' })
map('n', '<leader>Y', '"+Y', { desc = 'Yank line to clipboard' })

-- Delete without yanking
map({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete without yanking' })

-- ============================================================================
-- Window/Split Navigation (matching nvim/init.lua lines 104-111)
-- Ctrl+<hjkl> to switch between windows
-- ============================================================================
map('n', '<C-h>', function() vscode.action('workbench.action.focusLeftGroup') end, { desc = 'Move focus to the left window' })
map('n', '<C-l>', function() vscode.action('workbench.action.focusRightGroup') end, { desc = 'Move focus to the right window' })
map('n', '<C-j>', function() vscode.action('workbench.action.focusBelowGroup') end, { desc = 'Move focus to the lower window' })
map('n', '<C-k>', function() vscode.action('workbench.action.focusAboveGroup') end, { desc = 'Move focus to the upper window' })

-- ============================================================================
-- Diagnostic keymaps (matching nvim/init.lua line 88)
-- ============================================================================
map('n', '<leader>q', function() vscode.action('workbench.actions.view.problems') end, { desc = 'Open diagnostic [Q]uickfix list' })
map('n', ']d', function() vscode.action('editor.action.marker.next') end, { desc = 'Next diagnostic' })
map('n', '[d', function() vscode.action('editor.action.marker.prev') end, { desc = 'Previous diagnostic' })

-- ============================================================================
-- Search keymaps (matching Telescope keymaps from nvim/init.lua lines 337-369)
-- <leader>s = [S]earch
-- ============================================================================
map('n', '<leader>sh', function() vscode.action('workbench.action.showCommands') end, { desc = '[S]earch [H]elp/Commands' })
map('n', '<leader>sk', function() vscode.action('workbench.action.openGlobalKeybindings') end, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sf', function() vscode.action('workbench.action.quickOpen') end, { desc = '[S]earch [F]iles' })
map('n', '<leader>ss', function() vscode.action('workbench.action.showCommands') end, { desc = '[S]earch [S]elect Command' })
map('n', '<leader>sw', function() vscode.action('editor.action.addSelectionToNextFindMatch') end, { desc = '[S]earch current [W]ord' })
map('n', '<leader>sg', function() vscode.action('workbench.action.findInFiles') end, { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', function() vscode.action('workbench.actions.view.problems') end, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', function() vscode.action('workbench.action.openRecent') end, { desc = '[S]earch [R]ecent' })
map('n', '<leader>s.', function() vscode.action('workbench.action.openRecent') end, { desc = '[S]earch Recent Files ("." for repeat)' })
map('n', '<leader><leader>', function() vscode.action('workbench.action.showAllEditors') end, { desc = '[ ] Find existing buffers' })
map('n', '<leader>/', function() vscode.action('actions.find') end, { desc = '[/] Fuzzily search in current buffer' })
map('n', '<leader>s/', function() vscode.action('workbench.action.findInFiles') end, { desc = '[S]earch [/] in Open Files' })

-- ============================================================================
-- LSP keymaps (matching nvim/init.lua lines 446-481)
-- Using 'gr' prefix like standard Neovim LSP
-- ============================================================================
map('n', 'grn', function() vscode.action('editor.action.rename') end, { desc = 'LSP: [R]e[n]ame' })
map({ 'n', 'x' }, 'gra', function() vscode.action('editor.action.quickFix') end, { desc = 'LSP: [G]oto Code [A]ction' })
map('n', 'grr', function() vscode.action('editor.action.goToReferences') end, { desc = 'LSP: [G]oto [R]eferences' })
map('n', 'gri', function() vscode.action('editor.action.goToImplementation') end, { desc = 'LSP: [G]oto [I]mplementation' })
map('n', 'grd', function() vscode.action('editor.action.revealDefinition') end, { desc = 'LSP: [G]oto [D]efinition' })
map('n', 'grD', function() vscode.action('editor.action.revealDeclaration') end, { desc = 'LSP: [G]oto [D]eclaration' })
map('n', 'gO', function() vscode.action('workbench.action.gotoSymbol') end, { desc = 'LSP: Open Document Symbols' })
map('n', 'gW', function() vscode.action('workbench.action.showAllSymbols') end, { desc = 'LSP: Open Workspace Symbols' })
map('n', 'grt', function() vscode.action('editor.action.goToTypeDefinition') end, { desc = 'LSP: [G]oto [T]ype Definition' })

-- Additional LSP navigation
map('n', 'gd', function() vscode.action('editor.action.revealDefinition') end, { desc = 'Go to definition' })
map('n', 'gD', function() vscode.action('editor.action.revealDeclaration') end, { desc = 'Go to declaration' })
map('n', 'gr', function() vscode.action('editor.action.goToReferences') end, { desc = 'Go to references' })
map('n', 'gi', function() vscode.action('editor.action.goToImplementation') end, { desc = 'Go to implementation' })
map('n', 'gp', function() vscode.action('editor.action.peekDefinition') end, { desc = 'Peek definition' })

-- Hover
map('n', 'K', function() vscode.action('editor.action.showHover') end, { desc = 'Show hover' })

-- Toggle inlay hints (matching line 530-532)
map('n', '<leader>th', function() vscode.action('editor.inlayHints.toggle') end, { desc = '[T]oggle Inlay [H]ints' })

-- ============================================================================
-- Format (matching nvim/init.lua line 714)
-- ============================================================================
map({ 'n', 'v' }, '<leader>f', function() vscode.action('editor.action.formatDocument') end, { desc = '[F]ormat buffer' })

-- ============================================================================
-- Git keymaps (matching gitsigns from kickstart.plugins.gitsigns)
-- <leader>h = Git [H]unk
-- ============================================================================
map('n', ']c', function() vscode.action('workbench.action.editor.nextChange') end, { desc = 'Jump to next git [c]hange' })
map('n', '[c', function() vscode.action('workbench.action.editor.previousChange') end, { desc = 'Jump to previous git [c]hange' })
map('n', '<leader>hs', function() vscode.action('git.stageSelectedRanges') end, { desc = 'git [s]tage hunk' })
map('n', '<leader>hr', function() vscode.action('git.revertSelectedRanges') end, { desc = 'git [r]eset hunk' })
map('n', '<leader>hS', function() vscode.action('git.stage') end, { desc = 'git [S]tage buffer' })
map('n', '<leader>hu', function() vscode.action('git.unstage') end, { desc = 'git [u]nstage buffer' })
map('n', '<leader>hR', function() vscode.action('git.clean') end, { desc = 'git [R]eset buffer' })
map('n', '<leader>hp', function() vscode.action('editor.action.dirtydiff.next') end, { desc = 'git [p]review hunk' })
map('n', '<leader>hb', function() vscode.action('gitlens.toggleFileBlame') end, { desc = 'git [b]lame line' })
map('n', '<leader>hd', function() vscode.action('git.openChange') end, { desc = 'git [d]iff against index' })

-- ============================================================================
-- Toggle keymaps
-- <leader>t = [T]oggle
-- ============================================================================
map('n', '<leader>tb', function() vscode.action('gitlens.toggleFileBlame') end, { desc = '[T]oggle git show [b]lame line' })
map('n', '<leader>tD', function() vscode.action('git.openChange') end, { desc = '[T]oggle git show [D]eleted' })

-- ============================================================================
-- Comments (using VSCode's built-in commenting)
-- ============================================================================
map('n', 'gcc', function() vscode.action('editor.action.commentLine') end, { desc = 'Toggle line comment' })
map('v', 'gc', function() vscode.action('editor.action.commentLine') end, { desc = 'Toggle comment' })
map('n', 'gbc', function() vscode.action('editor.action.blockComment') end, { desc = 'Toggle block comment' })
map('v', 'gb', function() vscode.action('editor.action.blockComment') end, { desc = 'Toggle block comment' })

-- ============================================================================
-- Folding
-- ============================================================================
map('n', 'za', function() vscode.action('editor.toggleFold') end, { desc = 'Toggle fold' })
map('n', 'zc', function() vscode.action('editor.fold') end, { desc = 'Fold' })
map('n', 'zo', function() vscode.action('editor.unfold') end, { desc = 'Unfold' })
map('n', 'zC', function() vscode.action('editor.foldAll') end, { desc = 'Fold all' })
map('n', 'zO', function() vscode.action('editor.unfoldAll') end, { desc = 'Unfold all' })
map('n', 'zM', function() vscode.action('editor.foldAll') end, { desc = 'Fold all' })
map('n', 'zR', function() vscode.action('editor.unfoldAll') end, { desc = 'Unfold all' })

-- ============================================================================
-- File Explorer (like neo-tree)
-- ============================================================================
map('n', '<leader>e', function() vscode.action('workbench.action.toggleSidebarVisibility') end, { desc = 'Toggle sidebar' })
map('n', '<leader>E', function() vscode.action('workbench.view.explorer') end, { desc = 'Focus explorer' })

-- ============================================================================
-- Buffer/Tab navigation
-- ============================================================================
map('n', '<S-h>', function() vscode.action('workbench.action.previousEditor') end, { desc = 'Previous editor' })
map('n', '<S-l>', function() vscode.action('workbench.action.nextEditor') end, { desc = 'Next editor' })
map('n', '<leader>bd', function() vscode.action('workbench.action.closeActiveEditor') end, { desc = 'Close current editor' })
map('n', '<leader>bo', function() vscode.action('workbench.action.closeOtherEditors') end, { desc = 'Close other editors' })

-- ============================================================================
-- Split management
-- ============================================================================
map('n', '<leader>sv', function() vscode.action('workbench.action.splitEditor') end, { desc = 'Split editor vertically' })
map('n', '<leader>sH', function() vscode.action('workbench.action.splitEditorDown') end, { desc = 'Split editor horizontally' })

-- ============================================================================
-- Terminal
-- ============================================================================
map('n', '<C-`>', function() vscode.action('workbench.action.terminal.toggleTerminal') end, { desc = 'Toggle terminal' })

-- ============================================================================
-- Harpoon keybindings (matching nvim/lua/custom/plugins/harpoon.lua)
-- Install "Cursor Harpoon" extension for these to work
-- ============================================================================
map('n', '<leader>a', function() vscode.action('cursor-harpoon.addEditor') end, { desc = 'Harpoon: Add file' })
map('n', '<C-e>', function() vscode.action('cursor-harpoon.editEditors') end, { desc = 'Harpoon: Toggle quick menu' })
map('n', '<leader>1', function() vscode.action('cursor-harpoon.gotoEditor1') end, { desc = 'Harpoon: Go to file 1' })
map('n', '<leader>2', function() vscode.action('cursor-harpoon.gotoEditor2') end, { desc = 'Harpoon: Go to file 2' })
map('n', '<leader>3', function() vscode.action('cursor-harpoon.gotoEditor3') end, { desc = 'Harpoon: Go to file 3' })
map('n', '<leader>4', function() vscode.action('cursor-harpoon.gotoEditor4') end, { desc = 'Harpoon: Go to file 4' })
map('n', '<C-S-P>', function() vscode.action('cursor-harpoon.gotoPreviousHarpoonEditor') end, { desc = 'Harpoon: Previous file' })
map('n', '<C-S-N>', function() vscode.action('cursor-harpoon.gotoNextHarpoonEditor') end, { desc = 'Harpoon: Next file' })

-- ============================================================================
-- Cursor AI specific commands
-- ============================================================================
map('n', '<leader>ai', function() vscode.action('aipopup.action.modal.generate') end, { desc = 'Cursor: AI Generate' })
map('n', '<leader>ac', function() vscode.action('workbench.action.chat.open') end, { desc = 'Cursor: Open AI Chat' })
map('v', '<leader>ai', function() vscode.action('aipopup.action.modal.generate') end, { desc = 'Cursor: AI Generate (selection)' })

-- ============================================================================
-- Miscellaneous
-- ============================================================================
map('n', '<leader>zz', function() vscode.action('workbench.action.toggleZenMode') end, { desc = 'Toggle Zen mode' })
map('n', '<leader>,', function() vscode.action('workbench.action.openSettings') end, { desc = 'Open settings' })

-- Undo/Redo (use VSCode's undo system for better multi-cursor support)
map('n', 'u', function() vscode.action('undo') end, { desc = 'Undo' })
map('n', '<C-r>', function() vscode.action('redo') end, { desc = 'Redo' })

-- ============================================================================
-- Keybinding Reference (matching which-key groups from nvim/init.lua):
-- ============================================================================
-- <leader>s = [S]earch
-- <leader>t = [T]oggle
-- <leader>h = Git [H]unk
-- <leader>g = [G]it (additional)
-- <leader>a = [A]I/Code actions
-- <leader>b = [B]uffer commands
-- <leader>f = [F]ormat
-- <leader>q = [Q]uickfix/Diagnostics

print('Cursor Neovim config loaded!')
