require "csv"

#起動時に操作を選択（新規作成or編集）
puts "操作を選択してください"
puts "1(新規でメモを作成) 2(既存のメモを編集する) それ以外のキー(終了)"
memo_type = gets.to_s.chomp

class Memo
  def initialize(memo_type)
    @memo_type = memo_type
    @memo_title = ""
    @file_title = ""
    @revise_type = ""
  end

  def menu
    #1：新規でメモを作成
    if @memo_type == "1"
      create_new_memo()
    #2：既存のメモを編集
    elsif @memo_type == "2"
      revise_memo()
    else
      return
    end
  end

  def create_new_memo
    #保存時のCSVファイル名を入力(未入力は拒否)
    while @memo_title == "" do
      puts "保存時のファイル名を拡張子なしで入力してください"
      @memo_title = gets.to_s.chomp
    end
    #メモの内容入力
    puts "メモしたい内容を記入してください"
    puts "完了したら改行後に「Ctrl+D」を押してください"
    @memo_contents = readlines
    #メモの内容をCSVへ出力
    output = CSV.open("#{@memo_title}.csv","w")
      @memo_contents.each do |content|
        output.puts [content.chomp]
      end
    output.close
  end

  def revise_memo
    #呼び出したいCSVファイル名を入力(未入力は拒否)
    while @file_title == "" do
      puts "呼び出したいCSVファイル名を拡張子なしで入力してください"
      puts "（プログラムと同一フォルダに存在するCSVファイルのみ指定可）"
      @file_title = gets.to_s.chomp
    end
    #CSVファイルを読み込み、内容を出力
    puts "「#{@file_title}.csv」の内容は以下の通りです"
    puts "--------------------"
    CSV.foreach("#{@file_title}.csv") do |row|
      puts row
    end
    puts "--------------------"
    #行を追加or削除か選択
    while @revise_type == "" do
      puts "編集内容を選択してください"
      puts "1(行を追加) 2(行を削除) それ以外のキー(終了)"
      @revise_type = gets.to_s.chomp
    end
    #1：行を一番下に追加
    if @revise_type == "1"
      add_memo()
    #2：既存のメモを編集
    elsif @revise_type == "2"
      delete_memo()
    else
      return
    end
  end

  def add_memo
    #メモの内容入力
    puts "追加したい内容を記入してください（既存メモの一番下に追加されます）"
    puts "完了したら改行後に「Ctrl+D」を押してください"
    @memo_contents = readlines
    #メモの内容をCSVへ出力
    @tobeupdate_contents = CSV.read("#{@file_title}.csv")
    @memo_contents.each do |content|
      @tobeupdate_contents.push(content.chomp)
    end
    output = CSV.open("#{@file_title}.csv","w")
      @tobeupdate_contents.flatten.each do |newcontent|
        output.puts [newcontent]
      end
    output.close
  end

  def delete_memo
    #削除行選択
    puts "削除したい行番号を半角数字で入力してください"
    @delete_row = gets.to_i
    #入力された行番号が存在しているかチェック
    @tobeupdate_contents = CSV.read("#{@file_title}.csv").flatten
    if @tobeupdate_contents[@delete_row-1] == nil
      puts "入力された行番号は存在しません。終了します"
    else
      @tobeupdate_contents.delete_at(@delete_row-1)
      puts "#{@delete_row}行目の「#{@tobeupdate_contents[@delete_row-1]}」を削除しました"
    end
    output = CSV.open("#{@file_title}.csv","w")
      @tobeupdate_contents.each do |newcontent|
        output.puts [newcontent]
      end
    output.close
  end
end

memo = Memo.new(memo_type)
memo.menu()
