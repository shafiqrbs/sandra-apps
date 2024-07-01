echo -n "Do You Want To Run Dart Fix : "
echo -n "(y/n) "
read -r isDartFix

echo -n "What's your Commit : "
read -r commitMessage


echo
echo "Answers:"
echo "1. $isDartFix"
echo "2. $commitMessage"

if [ "$isDartFix" != "y" ];
 then
    echo "Dart Fix is not running"
  else
    echo "Dart Fix is running"
    dart fix --apply --code=require_trailing_commas
    dart fix --apply --code=prefer_final_locals
    dart fix --apply --code=use_decorated_box
    dart fix --apply --code=unused_import
    dart fix --apply --code=prefer_single_quotes
    dart fix --apply --code=prefer_const_constructors
    dart fix --apply --code=unnecessary_new
    dart fix --apply --code=prefer_int_literals
    dart fix --apply --code=avoid_redundant_argument_values
    dart fix --apply --code=unnecessary_null_comparison
    dart fix --apply --code=invalid_null_aware_operator
    dart fix --apply --code=unnecessary_parenthesis
    dart fix --apply --code=prefer_const_constructors

fi

git status
git add .
git commit -m "$commitMessage"
git push