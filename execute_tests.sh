#! /bin/sh
flutter test --coverage
echo "COVERAGE REPORT"
genhtml coverage/lcov.info -o coverage/html | grep "lines"
