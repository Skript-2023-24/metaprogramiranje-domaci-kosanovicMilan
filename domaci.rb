require "google_drive"

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
# See this document to learn how to create config.json:
# https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
session = GoogleDrive::Session.from_config("config.json")

ws = session.spreadsheet_by_key("1Ibt7tDiOiU6ESwsmfGDGu0pu9hDh5XuCBH6kSDMwt6Y").worksheets[0]

include Enumerable



valueRows = ws.num_rows
valueCol = ws.num_cols

# 1) Biblioteka vraca dvodimenzionalan niz

def ispisMatrice(ws,row,col)

    niz = []

    for i in 1..row

        red = []
    
        for j in 1..col
    
            red << ws[i,j]
    
        end
    
        niz << red
    
    end

        niz
end

p ispisMatrice(ws,valueRows,valueCol)

# 2) Pristupanje i-tom redu u sheet-u i ispis

matrica = ispisMatrice(ws,valueRows,valueCol)

red = matrica[0]

def pristupiRedu(red)

    niz = []

    for i in 0..red.size-1

        niz << red[i]

    end

        niz
end

p pristupiRedu(red)[1]







