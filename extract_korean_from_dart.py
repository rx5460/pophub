import os
import re
import json
import time
from googletrans import Translator

def extract_korean(text):
    # 주석 제거
    text = re.sub(r'//.*?$|/\*.*?\*/', '', text, flags=re.MULTILINE | re.DOTALL)
    
    # ${...} 패턴을 빈 중괄호로 대체
    text = re.sub(r'\$\{[^}]*\}', '{}', text)
    
    # 변수명과 한글 텍스트를 함께 추출 (### 로 시작하지 않는 경우만)
    pattern = re.compile(r'(\w+)\s*[:=]\s*[\'"]([^\'"]*?[가-힣]+[^\'"]*?)[\'"]')
    matches = [(var, txt) for var, txt in pattern.findall(text) if not txt.strip().startswith('###')]
    
    # 변수명이 없는 경우를 위한 패턴 (### 로 시작하지 않는 경우만)
    fallback_pattern = re.compile(r'[\'"]([^\'"]*?[가-힣]+[^\'"]*?)[\'"]')
    fallback_matches = [txt for txt in fallback_pattern.findall(text) if not txt.strip().startswith('###')]
    
    return matches, fallback_matches

def generate_variable_name(text, translator):
    max_retries = 3
    for attempt in range(max_retries):
        try:
            # 한글을 영어로 번역
            translation = translator.translate(text, src='ko', dest='en', timeout=10).text
            
            # 특수문자 제거 및 공백을 언더스코어로 변경
            variable_name = re.sub(r'[^\w\s]', '', translation).replace(' ', '_').lower()
            
            # 변수명이 비어있거나 숫자로 시작하는 경우 처리
            if not variable_name or variable_name[0].isdigit():
                variable_name = 'var_' + variable_name
            
            return variable_name or 'unnamed_var'
        except Exception as e:
            print(f"Translation error for '{text}' (Attempt {attempt + 1}/{max_retries}): {e}")
            time.sleep(2)  # 재시도 전 2초 대기
    
    # 모든 시도가 실패하면 원본 텍스트를 변수명으로 사용
    return re.sub(r'[^\w\s]', '', text).replace(' ', '_').lower() or 'unnamed_var'

def process_dart_files(folder_path):
    korean_texts = {}
    translator = Translator()
    
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as dart_file:
                        content = dart_file.read()
                except UnicodeDecodeError:
                    try:
                        with open(file_path, 'r', encoding='cp949') as dart_file:
                            content = dart_file.read()
                    except UnicodeDecodeError:
                        print(f"Warning: Unable to read {file_path}. Skipping this file.")
                        continue
                
                matches, fallback_matches = extract_korean(content)
                
                # 모든 매치에 대해 처리
                all_matches = matches + [(None, text) for text in fallback_matches]
                for var_name, text in all_matches:
                    if text not in korean_texts.values():
                        if not var_name:
                            var_name = generate_variable_name(text, translator)
                        base_name = var_name
                        counter = 1
                        while var_name in korean_texts:
                            var_name = f"{base_name}_{counter}"
                            counter += 1
                        korean_texts[var_name] = text
                        time.sleep(0.5)  # API 호출 제한을 피하기 위한 지연
    
    # JSON 파일로 저장
    output_file = 'korean_texts_from_dart.json'
    with open(output_file, 'w', encoding='utf-8') as json_file:
        json.dump(korean_texts, json_file, ensure_ascii=False, indent=2)
    
    print(f"한글 텍스트가 {output_file}에 저장되었습니다.")
    print(f"총 {len(korean_texts)}개의 고유한 한글 텍스트가 추출되었습니다.")

if __name__ == "__main__":
    # pophub_front 폴더 경로를 지정하세요
    folder_path = os.path.abspath('/Users/hwangjimin/Documents/dev/proj/pophub/pophub_front')
    if not os.path.exists(folder_path):
        print(f"Error: The folder {folder_path} does not exist.")
    else:
        process_dart_files(folder_path)