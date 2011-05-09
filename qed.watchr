watch 'lib/.*\.rb' do |md|
  system "qed -t Bezel qed/"
end

watch 'qed/.*\.rdoc' do |md|
  system "qed -t Bezel qed/"
end

