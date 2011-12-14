#! /bin/bash
find . -name "*.[hm]" | xargs sed -Ee 's/ +$//g' -i ""
