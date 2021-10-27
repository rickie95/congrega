#! /bin/sh
flutter test --coverage --no-sound-null-safety
echo "COVERAGE REPORT"
genhtml coverage/lcov.info -o coverage/html > tests-log.txt
cat tests-log.txt| grep "lines"
