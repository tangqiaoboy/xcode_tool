#! /bin/bash
find . -name "*.[hm]" | xargs sed -Ee 's/ +$//g' -i ""
find . -name "*.mm" | xargs sed -Ee 's/ +$//g' -i ""
