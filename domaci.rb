require "google_drive"

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
# See this document to learn how to create config.json:
# https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
session = GoogleDrive::Session.from_config("config.json")

spreadsheet_key = "1Ibt7tDiOiU6ESwsmfGDGu0pu9hDh5XuCBH6kSDMwt6Y"

ws = session.spreadsheet_by_key(spreadsheet_key).worksheets[0]




class GoogleSheetTable
    include Enumerable
  
    def initialize(session, spreadsheet_key, worksheet_index)
      @session = session
      @spreadsheet_key = spreadsheet_key
      @worksheet_index = worksheet_index
    end
  
    def ispis_matrice
      worksheet = @session.spreadsheet_by_key(@spreadsheet_key).worksheets[@worksheet_index]
  
      niz = []
  
      worksheet.num_rows.times do |i|
        red = []
  
        worksheet.num_cols.times do |j|
          red << worksheet[i + 1, j + 1]
        end
  
        niz << red
      end
  
      niz
    end

    def sum(column_name)
        column_values = get_column(column_name)
        column_values.sum
      end
    
      # Metoda za računanje proseka vrednosti u koloni
      def avg(column_name)
        column_values = get_column(column_name)
        return 0 if column_values.empty?
    
        column_values.sum / column_values.size.to_f
      end

    def magdalena
        get_column("magdalena")
      end
    
      def cao
        get_column("cao")
      end
    
      def broski
        get_column("broski")
      end
  
      

    def pristupiRedu(red)
      niz = []
      red.each { |element| niz << element }
      niz
    end
  
    def [](index)
      case index
      when String
        get_column(index)
      when Integer
        get_row(index)
      else
        # Ponašanje kada se koristi drugi tip indeksa
        # Možete dodati odgovarajući kod prema vašim potrebama
      end
    end
  
    def []=(index, value)
      case index
      when String
        set_column(index, value)
      when Integer
        set_row(index, value)
      else
        # Ponašanje kada se koristi drugi tip indeksa
        # Možete dodati odgovarajući kod prema vašim potrebama
      end
    end
  
    def each(&block)
        worksheet = @session.spreadsheet_by_key(@spreadsheet_key).worksheets[@worksheet_index]
    
        worksheet.rows.each do |row|
          next if row_contains_keyword?(row, 'total', 'subtotal')
    
          row.each do |cell|
            yield cell unless cell.nil? || cell.to_s.strip.empty?
          end
        end
      end
    
      private
    
      def row_contains_keyword?(row, *keywords)
        row.to_a.any? do |cell|
          keywords.any? { |keyword| cell.to_s.downcase.include?(keyword) }
        end
      end
    def method_missing(method, *args)
        if match = method.to_s.match(/^([a-zA-Z0-9]+)\.sum$/)
          get_column_sum(match[1])
        elsif match = method.to_s.match(/^([a-zA-Z0-9]+)\.avg$/)
          get_column_avg(match[1])
        elsif match = method.to_s.match(/^([a-zA-Z0-9]+)\.broj\.rn(\d+)$/)
            get_row_by_identifier(match[1], "rn#{match[2]}")
          else
            super
          end
      end
    
      private

    

  def get_row_by_cell_value(column_name, cell_value)
    worksheet = @session.spreadsheet_by_key(@spreadsheet_key).worksheets[@worksheet_index]
    header_row = worksheet.rows[0]

    # Pronalaženje indeksa tražene kolone
    column_index = header_row.find_index(column_name)

    # Ako kolona nije pronađena, nema šta dohvatiti
    return [] if column_index.nil?

    # Pronalaženje reda na osnovu vrednosti u traženoj koloni
    row_index = worksheet.rows.find_index { |row| row[column_index] == cell_value }

    # Ako red nije pronađen, nema šta dohvatiti
    return [] if row_index.nil?

    # Vraćanje reda kao niza vrednosti
    worksheet[row_index + 1].reject { |value| value.nil? || value.to_s.strip.empty? }  # +1 jer su indeksi u tabeli od 1
  end
    
      def get_column_sum(column_name)
        column_values = get_column(column_name)
        numeric_values = column_values.map do |value|
          numeric_value(value) || (puts "Nije numerička vrednost: #{value}"; 0)
        end
        numeric_values.compact.sum
      end
    
      def get_column_avg(column_name)
        column_values = get_column(column_name)
        numeric_values = column_values.map do |value|
          numeric_value(value) || (puts "Nije numerička vrednost: #{value}"; 0)
        end
        return 0 if numeric_values.empty?
    
        numeric_values.compact.sum / numeric_values.size.to_f
      end
    
      def numeric_value(value)
        if value =~ /\A\d+\z/ # Provera da li je vrednost celobrojna
          value.to_i
        else
          puts "Nije moguće konvertovati u integer: #{value}"
          nil
        end
      end
  
    private
  
    def get_column(column_name, skip_first_row: true)
        worksheet = @session.spreadsheet_by_key(@spreadsheet_key).worksheets[@worksheet_index]
        header_row = worksheet.rows[0]
      
        # Pronalaženje indeksa tražene kolone
        column_index = header_row.find_index(column_name)
      
        # Ako kolona nije pronađena, nema šta postaviti
        return [] if column_index.nil?
      
        # Prolazak kroz redove i dobijanje vrednosti za traženu kolonu
        column_values = worksheet.rows.map.with_index do |row, i|
          next if i.zero? && skip_first_row
      
          row[column_index]
        end
      
        # Preskakanje praznih vrednosti u koloni
        column_values.compact.reject { |value| value.to_s.strip.empty? }
      end
      
  
    def get_row(row_index)
      worksheet = @session.spreadsheet_by_key(@spreadsheet_key).worksheets[@worksheet_index]
  
      # Vraćanje reda kao niza vrednosti
      worksheet[row_index + 1].reject { |value| value.nil? || value.to_s.strip.empty? }  # +1 jer su indeksi u tabeli od 1
    end
  
    def set_column(column_name, values)
      worksheet = @session.spreadsheet_by_key(@spreadsheet_key).worksheets[@worksheet_index]
      header_row = worksheet.rows[0]
  
      # Pronalaženje indeksa tražene kolone
      column_index = header_row.find_index(column_name)
  
      # Ako kolona nije pronađena, nema šta postaviti
      return if column_index.nil?
  
      # Postavljanje vrednosti za traženu kolonu
      values.each_with_index do |value, i|
        worksheet[i + 2, column_index + 1] = value  # +1 jer su indeksi u tabeli od 1, +1 jer preskačemo header red
      end
  
      # Snimanje promena
      worksheet.synchronize
    end
  
    def set_row(row_index, values)
      worksheet = @session.spreadsheet_by_key(@spreadsheet_key).worksheets[@worksheet_index]
  
      # Postavljanje vrednosti za traženi red
      values.each_with_index do |value, i|
        worksheet[row_index + 1, i + 1] = value  # +1 jer su indeksi u tabeli od 1
      end
  
      # Snimanje promena
      worksheet.synchronize
    end
  end
  
  


  table = GoogleSheetTable.new(session, spreadsheet_key, 0)

  p "Ispis matrice"
  p table.ispis_matrice

  p "Pristup redu"
  p table.pristupiRedu(ws.rows[1])

p "Ispisivanje svih celija sa leva na desno"
  table.each do |cell|
    puts cell
  end

p "Pristupanje koloni na osnovu njenog imena"
p table['magdalena']
p "Ispis tacnog elementa iz kolone po indeksu"

p table['magdalena'][2]

 p "Vrednost promenjena uspesno u tabeli !"
  table['magdalena'][3] = 2000

  ws.save

  p table.magdalena

  # table.broj.rn202
  

 

  




