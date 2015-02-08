from plugin.search import universal

info = {"plugin_name"           : "grep",
        "binary_name"           : "grep",
        "types"                 : ["plain"],
        "switches"              : ["-rn", "--color=never"],
        "switch_ignore_case_on" : "--ignore-case"}

class Results:

    search_term = None
    search_path = None
    ignore_case = False

    def search(self):
        r = universal.Results(info)
        r.search_term = self.search_term
        r.search_path = self.search_path
        r.ignore_case = self.ignore_case
        return r.search()
