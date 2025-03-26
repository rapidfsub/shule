#!/bin/sh

for dir in ./*; do
  # test-framework 디렉토리는 제외
  [ "$dir" = "./test-framework" ] && continue
  [ -d "$dir" ] || continue

  LINK_PATH="$dir/test-framework"

  # test-framework가 존재하면 삭제
  if [ -e "$LINK_PATH" ]; then
    echo "Remove: $LINK_PATH"
    rm -rf "$LINK_PATH"
  fi

  if [ -L "$LINK_PATH" ]; then
    # 이미 심볼릭 링크면 아무것도 안 함
    echo "Skip: $LINK_PATH is already a symlink"
  else
    # 심볼릭 링크 생성
    echo "Link: $LINK_PATH → ../test-framework"
    ln -s ../test-framework "$LINK_PATH"
  fi
done
