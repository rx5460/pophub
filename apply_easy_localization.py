import os
import json
import re

def load_translations(json_file):
    with open(json_file, 'r', encoding='utf-8') as f:
        return json.load(f)

def replace_text_in_file(file_path, translations):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    for key, value in translations.items():
        pattern = rf'["\']({re.escape(value)})["\']'
        replacement = f"('{key}').tr()"
        content = re.sub(pattern, replacement, content)

    # Add import statement if not present
    import_statement = "import 'package:easy_localization/easy_localization.dart';"
    if import_statement not in content:
        imports = re.findall(r'^import.*?;[\r\n]+', content, re.MULTILINE)
        if imports:
            # Insert the new import after the last import
            last_import = imports[-1]
            content = content.replace(last_import, f"{last_import}\n{import_statement}\n")
        else:
            # If no imports found, add at the beginning of the file
            content = f"{import_statement}\n\n{content}"

    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Changes made in: {file_path}")
    else:
        print(f"No changes in: {file_path}")

def process_dart_files(directory, translations):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                replace_text_in_file(file_path, translations)

# 메인 실행 부분
json_file = 'korean_texts_from_dart.json'
dart_directory = os.path.abspath('/Users/hwangjimin/Documents/dev/proj/pophub/pophub_front')

translations = load_translations(json_file)
print(f"Loaded {len(translations)} translations")

process_dart_files(dart_directory, translations)

print("All .dart files have been processed.")
