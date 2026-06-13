#!/bin/sh

cat > update_config.py << EOF
import sys
from pathlib import Path
import os

if len(sys.argv) != 3:
  print("ERROR: Missing arguments")
  print("update_config.py usage:")
  print("update_config.py config_file patches_file")
  sys.exit()

config_to_update = sys.argv[1]
patch = sys.argv[2]

if not(Path(config_to_update).is_file()):
  print(f"ERROR: File [{config_to_update}] not found!")
  sys.exit()

if not(Path(patch).is_file()):
  print(f"ERROR: File [{patch}] not found!")
  sys.exit()

with open(config_to_update) as f:
    config_list = f.readlines()
config_list = [x.strip() for x in config_list]

with open(patch) as f:
    patch_list = f.readlines()
patch_list = [x.strip() for x in patch_list]

class Comment():
  def __init__(self, comment):
    self.comment = comment
  def __repr__(self):
    return f"{self.comment}"
class NotSet():
  def __init__(self, key):
    self.key = key
  def __repr__(self):
    return f"# {self.key} is not set"
class KeyValue():
  def __init__(self, key, value):
    self.key = key
    self.value = value
  def __repr__(self):
    return f"{self.key}={self.value}"

def transformToObjects(line):
  if line.startswith("# ") and line.endswith(" is not set"):
    return NotSet(line[2:][:-11])
  elif not(line.startswith("#")) and "=" in line:
    return KeyValue(line.split("=")[0], line.split("=")[1])
  else:
    return Comment(line)

config_objs=list(map(transformToObjects, config_list))
patch_objs=set(map(transformToObjects, patch_list))
results=[]
patch_objs_to_remove=[]

for c in config_objs:
  match c:
    case Comment():
      results.append(c)
    case NotSet():
      toAdd=c
      for p in patch_objs:
        if hasattr(p, 'key') and p.key == c.key:
          toAdd=p
          patch_objs_to_remove.append(p)
      results.append(toAdd)
    case KeyValue():
      toAdd=c
      for p in patch_objs:
        if hasattr(p, 'key') and p.key == c.key:
          toAdd=p
          patch_objs_to_remove.append(p)
      results.append(toAdd)

for r in patch_objs_to_remove:
  patch_objs.remove(r)

os.truncate(config_to_update, 0)

with open(config_to_update, "a") as myfile:
    for r in results:
      myfile.write(f"{r.__repr__()}\n")
    for p in patch_objs:
      myfile.write(f"{p.__repr__()}\n")

EOF

python3 update_config.py $1 $2
