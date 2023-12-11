#!/bin/bash

# The curl command transfers the data from the wikipedia article
# The -s means that the command will run in silent mode (not show progress or error messages)
# The > transfers the data from the article into (and creates) a .txt file with a name of my liking
curl -s https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway > "step_1.page.html.txt"

# cat is short for "concatenate" and allows files to concatenate (link). In this case cat is used 
# to read the content of the file that was created in the previous command.
# The | (pipe) works as a bridge, taking the output from the cat-command and transfers it to the next command.
# The tr command means translate, -d command deletes whatever in single quotation marks (in this case n (newline 
# characters) ant t (tab characters)).
# > takes the output from the translate (tr) command and transfers it into a new text file of my choice. 
cat "step_1.page.html.txt" | tr -d '\n\t' > "step_2.no-newlines.html.txt"

# sed means "stream editor" and is a text manipulator. Here it substitutes ('s) the table we want to use by searching for the "pattern" in the file 
# that includes the tag <table> with the class "sortable wikitable" and replaces it with a modified string "sortable wikipage"
# The strings are taken from the .txt file of the previous step. The pipe transfers the output to the next command which 
# does the substitute strings in the closing tag of the table and finally transfers the data into a new text file of my own
# liking. \1 will capture the pattern (in this case it is the table), \n creates a new line and |g is closing the expression.
sed -E 's|<table class="sortable wikitable">|\n<table class="sortable wikipage">|' "step_2.no-newlines.html.txt" |
    sed -E 's|(</table>)|</table>\1\n|g' > "step_3.table-newline.html.txt"

# -n removes automatic formatting so that only the content that is specified will be printed (here '3p' which means 
# "print line no. 3.") from the previous .txt file and transferred (>) into out final .txt file.
sed -n '3p' "step_3.table-newline.html.txt" > "step_4.table.html.txt"

#This is the page template of the HTML page.
# NB: I initially misspelled "municipalities" to "mumicipalities" in my h1 heading. This is why I decided to have some 
# fun with it and add a "dancing mummy gif" on my page. I later changed the heading to "mummycipalities", to make the joke
# even more obvious, but not sure it turned out that funny. But at least it made the page itself slightly more entertaining. 
page_template='
<!DOCTYPE html >
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Kaia`s table of municipalities</title>
    <style>
    body {
    background-color: rgb(251, 121, 121);
}

header {display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
}

h1 {
    font-family: Arial, Helvetica, sans-serif;
    color: rgb(255, 255, 255);
    text-shadow:black 1px;
    padding: 10%;
    font-size: 300%;
}

header img {
    width: 200%;
}

p {
    font-size: x-large;
}

table {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 1%;
    border: solid rgb(0, 0, 0) 1px;
    background-color: white;
}
</style>
  </head>
  <body>
    <script src="index.js"></script>
    <header>
    <h1>My table of Norwegian mummycipalities</h1>
    <figure>
    <img
        src="./assets/animated-mummy-image-0007.gif"
        alt="Dancing Mummy"/>
    </figure>
    </header>
    <p>Candidate number: 10021</p>
    '"$(cat "step_4.table.html.txt")"'
  </body>
</html>
'

# Finally the template with the final .txt file is transferred into an actual HTML file that can then be opened in
# a browser and manipulated with CSS.
echo "$page_template" > "index.html"
