import os
import pyperclip
import pprint
import xml.etree.ElementTree as ET
import re

src = pyperclip.paste()
materials = []
textures = []
bad_mats = []

for folders, subfolders, files in os.walk(src):
    for file in files:
        low_file = file.lower()
        if low_file.endswith('.material'):
            materials.append(os.path.join(folders, file))
        if low_file.endswith('tga') or low_file.endswith('dds'):
            file = os.path.join(folders, file)
            file = file.split('\\')
            scenery_index = file.index('scenery') + 1
            file = '/'.join(file[scenery_index:])
            textures.append(file)

bad_text = r'<element class="MaterialLayer" class="MaterialLayer">'
good_text = r'<element class="MaterialLayer">'
textures_pattern = re.compile(r'[\/\w\s]+\.tga', re.IGNORECASE)

for mat in materials:
    try:
        tree = ET.parse(mat)
        root = tree.getroot()
        for obj in tree.findall('*/*/object'):
            if obj.attrib['name'] == 'TexturesHolder':
                for texture in obj.findall('*/texture'):
                    if 'name' in texture.keys() or 'fullName' in texture.keys():
                        if 'fullName' in texture.keys():
                            full_name = texture.attrib['fullName']
                            text_list = textures_pattern.findall(full_name)
                            for text in text_list:
                                if text in textures:
                                    textures.remove(text)
                        else:
                            for layer in texture.findall('layer'):
                                if layer.attrib['path'] in textures:
                                    textures.remove(layer.attrib['path'])

        # break
    except ET.ParseError:
        bad_mats.append(mat)

pprint.pp(textures)
