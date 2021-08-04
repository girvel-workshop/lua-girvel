-- import sys, os, bash
-- 
-- ROOT = str(bash('git rev-parse --show-toplevel'))
-- version, build = (int(i) for i in next(
	-- f for f in os.listdir(ROOT) if f.endswith('.rockspec')
-- )[7:-9].split('-'))
-- 
-- os.system("git add .")
-- os.system("git commit -m " + repr(sys.argv[1]))
-- os.system("git tag")

require "sh"
require "strong"
fnl = require "fnl"

ROOT = tostring(git "rev-parse --show-toplevel")
old_rockspec = unpack(
	tostring(ls()):split("%s") / fnl.filter[[it:endsWith('.rockspec')]]
)

version, build = unpack(old_rockspec:sub(8, -10):split("-"))
build = tonumber(build) + 1
newstamp = version .. "-" .. build
print(newstamp)

rockspec_content = tostring(cat(old_rockspec))
print(
	echo(
		rockspec_content
			:gsub("version=%S*", 'version="%s"' % newstamp)
			:gsub("tag=%S*", 'tag="%s"' % newstamp)
	):tee(old_rockspec)
)

print(mv(
	'"%s" "girvel-%s.rockspec"' % {old_rockspec, newstamp}
))
print("Moved to version", newstamp)

print(git "add .")
print(git('commit -m "%s"' % arg[1]))
print(git('tag -a "%s" -m "build %s"' % {newstamp, newstamp}))

print(git('push origin master'))
print(git('push origin tags'))

print("Uploading rock")
print(luarocks("upload girvel-*.rockspec --api-key=%s" % arg[2]))
