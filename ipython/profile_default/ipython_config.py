# from IPython.terminal.prompts import Prompts, Token
#
# class MyPrompt(Prompts):
#     def in_prompt_tokens(self, cli=None):
#         return [(Token.Prompt, 'py❯ ')]
#
#     def continuation_prompt_tokens(self, cli=None, width=None):
#         return [(Token.Prompt, '... ')]
#
#     def rewrite_prompt_tokens(self):
#         return []
#
#     def out_prompt_tokens(self):
#         return []

# c.TerminalInteractiveShell.prompts_class = MyPrompt

c.InteractiveShell.automagic = False
c.InteractiveShell.colors = 'Linux'
c.TerminalInteractiveShell.display_completions = 'readlinelike'
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalIPythonApp.display_banner = False
