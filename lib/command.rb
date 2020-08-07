# frozen_string_literal: true

require "optparse"
require "./lib/text.rb"

class Command
  def self.option_parse
    @params = {}
    opt = OptionParser.new
    opt.on('-n', '--nameless') { _1 }
    opt.parse!(ARGV, into: @params)
  end

  def self.exec
    option_parse
    puts "Slackのメッセージを貼り付けてください。"
    puts "読み込みを終了するにはCtrl + Dを入力してください。"
    message = $stdin.readlines
    message = Text.delete_all(message, ARGV)
    5.times { puts "**************************************************************" }
    message.each do |str|
      puts str
    end
  end
end

Command.exec
