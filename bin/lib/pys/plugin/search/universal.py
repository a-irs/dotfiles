### combines ack, ag, grep, pdfgrep

import shutil
import subprocess
import locale

class Results:

    ignore_case = False
    search_term = None
    search_path = None

    caller = None

    def __init__(self, caller):
        self.caller = caller

    def search(self):
        proc = subprocess.Popen(self.build_command(),
            stdout=subprocess.PIPE, universal_newlines=False)
        output = proc.communicate()[0]

        results = []
        for line in output.splitlines():
            try:
                s = line.decode('utf-8').split(':', 2)

                # only add if there is a real line number
                l = None
                try:
                    float(s[1])
                    l = s[1]
                except ValueError:
                    l = 0
                r = SingleResult(filename=s[0], line_number=l, context="".join(s[2:]))
                results.append(r)
            except IndexError as e:
                pass
            except UnicodeDecodeError as e:
                pass
        return results

    def build_command(self):
        tool = shutil.which(self.caller["binary_name"])
        command = [tool] + self.caller["switches"]

        if self.ignore_case and self.caller.get("switch_ignore_case_on") is not None:
            command.append(self.caller.get("switch_ignore_case_on"))
        elif self.caller.get("switch_ignore_case_off") is not None:
            command.append(self.caller.get("switch_ignore_case_off"))

        command.append(self.search_term)
        command.append(self.search_path)

        return command


class SingleResult:

    def __init__(self, filename, line_number, context):
        self.filename = filename
        self.line_number = line_number
        self.context = context

    def __str__(self):
        return self.filename + ":" + self.line_number + ":" + self.context

