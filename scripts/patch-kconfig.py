#!/usr/bin/python
import sys

kconfig_file = sys.argv[1];
patch_file = sys.argv[2];

print ("patching %s with %s " % (kconfig_file , patch_file));

patch_lines = [line.strip() for line in open(patch_file)]
conf_lines = [line.strip() for line in open(kconfig_file)]



for pl in patch_lines:
	if len(pl) < 3 or pl[0] == '#':
		continue;
	pl = pl.partition("#")[0].strip().split(" ");

	if pl[1] != 'y' and pl[1] != 'n' and pl[1] != 'm':
		print('Invalid');
		print(pl);
		exit(1);

	isState='n'
	i = -1;
	for cli,cl in enumerate(conf_lines):
		if len(cl) < 3 or cl[0] == '#' or (pl[0]+'=') not in cl:
			continue;		
		isState = 'y' if ((pl[0]+"=y") in cl) else ( 'm' if ((pl[0]+"=m") in cl) else '?' )
		i = cli
		print(cl)
		break

	if isState =='?':
		print('Invalid state for '+pl[0]);
		exit(1);

	
	shallState = pl[1]

	if not isState == shallState:
		if shallState == 'n':
			print('Unsetting ' + pl[0]);
			conf_lines[i] = '# %s is not set' % pl[0]
		elif i >= 0:
			print('Setting ' + pl[0]);
			conf_lines[i] = '='.join(pl)
		else:
			print('Appending ' + pl[0]);
			conf_lines.append('='.join(pl))


f = open(kconfig_file,'w')
f.write('\n'.join(conf_lines))
f.close()
		
