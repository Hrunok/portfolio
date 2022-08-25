import os
import time
from PIL import Image

old_textures_path = input('Enter your old textures path here: ')
new_textures_path = input('Enter your new textures path here: ')
out_info = old_textures_path + '\t' + new_textures_path + '\n'

old_textures_list = os.listdir(old_textures_path)
new_textures_list = os.listdir(new_textures_path)
unsorted_files = [[], []]

old_new_pairs = {}

for old_text in old_textures_list:
    mat_name = os.path.splitext(old_text)[0]
    old_new_pairs[old_text] = []
    for new_text in new_textures_list:
        if new_text.lower().startswith(mat_name.lower()):
            old_new_pairs[old_text].append(new_text)
            if '_albedo' in new_text.lower():
                im = Image.open(os.path.join(new_textures_path, new_text))
                if im.pixel_format == 'DXT5':
                    old_new_pairs[old_text].append('alpha')
    if not old_new_pairs[old_text]:
        del old_new_pairs[old_text]
        unsorted_files[0].append(old_text)

for (key, values) in old_new_pairs.items():
    for value in values:
        if value in new_textures_list:
            new_textures_list.remove(value)
    out_info += key + '\t' + ','.join(values) + '\n'

unsorted_files[1] = new_textures_list
out_info += '\n'
out_info += '=' * 20 + '\n'
out_info += 'Unsorted files:\n'
out_info += '\n'
out_info += 'OLD TEXTURES:\n'
out_info += '\n'.join(unsorted_files[0])
out_info += '\n' * 2
out_info += 'NEW TEXTURES:\n'
out_info += '\n'.join(unsorted_files[1])

with open(os.path.join(new_textures_path, 'textures_info.txt'), 'w') as out_file:
    out_file.write(out_info)

time.sleep(20)