return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
    "nvim-tree/nvim-web-devicons" -- Recommended but not required. Icons in discussion tree.
  },
  enabled = true,
  build = function () require("gitlab.server").build(true) end, -- Builds the Go binary
  config = function()
    require("gitlab").setup()
  end,
}
--[[

          disable_all = false, -- Disable all global mappings created by the plugin
          add_assignee = "glaa",
          delete_assignee = "glad",
          add_label = "glla",
          delete_label = "glld",
          add_reviewer = "glra",
          delete_reviewer = "glrd",
          approve = "glA", -- Approve MR
          revoke = "glR", -- Revoke MR approval
          merge = "glM", -- Merge the feature branch to the target branch and close MR
          create_mr = "glC", -- Create a new MR for currently checked-out feature branch
          choose_merge_request = "glc", -- Chose MR for review (if necessary check out the feature branch)
          start_review = "glS", -- Start review for the currently checked-out branch
          summary = "gls", -- Show the editable summary of the MR
          copy_mr_url = "glu", -- Copy the URL of the MR to the system clipboard
          open_in_browser = "glo", -- Openthe URL of the MR in the default Internet browser
          create_note = "gln", -- Create a note (comment not linked to a specific line)
          pipeline = "glp", -- Show the pipeline status
          toggle_discussions = "gld", -- Toggle the discussions window
          toggle_draft_mode = "glD", -- Toggle between draft mode (comments posted as drafts) and live mode (comments are posted immediately)
          publish_all_drafts = "glP", -- Publish all draft comments/notes
]]
