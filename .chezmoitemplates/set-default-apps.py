"""Reconcile Launch Services default-app handlers for file extensions.

argv[1]: JSON object of bundle id -> list of extensions.
Entries are keyed by extension tag, which Launch Services prefers over
content-type entries, and are written through cfprefsd so no consent
dialog appears. Prints 'changed' or 'unchanged'.
"""

import json
import plistlib
import subprocess
import sys

DOMAIN = "com.apple.LaunchServices/com.apple.launchservices.secure"
TAG_CLASS = "public.filename-extension"

mapping = json.loads(sys.argv[1])
wanted = {ext: bundle for bundle, exts in mapping.items() for ext in exts}

exported = subprocess.run(["defaults", "export", DOMAIN, "-"], check=True, capture_output=True).stdout
prefs = plistlib.loads(exported)
handlers = prefs.get("LSHandlers", [])


def managed(handler):
    return handler.get("LSHandlerContentTagClass") == TAG_CLASS and handler.get("LSHandlerContentTag") in wanted


current = {h["LSHandlerContentTag"]: h.get("LSHandlerRoleAll") for h in handlers if managed(h)}
if current == wanted and sum(managed(h) for h in handlers) == len(wanted):
    print("unchanged")
    sys.exit(0)

kept = [h for h in handlers if not managed(h)]
kept.extend(
    {"LSHandlerContentTag": ext, "LSHandlerContentTagClass": TAG_CLASS, "LSHandlerRoleAll": bundle}
    for ext, bundle in wanted.items()
)
prefs["LSHandlers"] = kept
subprocess.run(["defaults", "import", DOMAIN, "-"], check=True, input=plistlib.dumps(prefs))
print("changed")
