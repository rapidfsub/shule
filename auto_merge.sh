#!/bin/sh

# 현재 브랜치 확인
current_branch=$(git branch --show-current)

# prefix: 마지막 / 앞까지 (POSIX sed)
prefix=$(echo "$current_branch" | sed 's,/[^/]*$,,')
# suffix: 마지막 / 뒤 한 단어 (POSIX sed)
suffix=$(echo "$current_branch" | sed 's,^.*/,,')

# 현재 브랜치가 develop인 경우
if [ "$current_branch" = "develop" ]; then
  echo "이미 develop 브랜치에 있습니다."
  exit 0
fi

# 머지할 대상 브랜치 결정
if [ "$suffix" = "develop" ]; then
  # */develop -> develop
  target_branch="develop"
else
  # */* -> */develop
  target_branch="$prefix/develop"
fi

# 대상 브랜치로 체크아웃
echo "$target_branch로 체크아웃합니다..."
git checkout "$target_branch"

# 현재 브랜치를 대상 브랜치로 머지
echo "$current_branch를 $target_branch로 머지합니다..."
git merge --no-ff --no-edit "$current_branch"

if [ $? -eq 0 ]; then
  echo "머지가 성공적으로 완료되었습니다."
  # 현재 브랜치 삭제
  echo "$current_branch 브랜치를 삭제합니다..."
  git branch -d "$current_branch"
  if [ $? -eq 0 ]; then
    echo "$current_branch 브랜치가 삭제되었습니다."
  else
    echo "Warning: $current_branch 브랜치 삭제에 실패했습니다."
  fi
else
  echo "Error: 머지에 실패했습니다."
  exit 1
fi
