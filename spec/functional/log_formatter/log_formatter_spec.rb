require_relative '../../../classes/log_formatter/log_formatter'

describe LogFormatter do
  context 'n/a' do
    it 'should return n/a when nil' do
      expect(LogFormatter.NA_when_empty(nil)).to eq('n/a')
    end

    it 'should return n/a when empty' do
      expect(LogFormatter.NA_when_empty('')).to eq('n/a')
    end

    it 'should return white space when white space' do
      expect(LogFormatter.NA_when_empty(' ')).to eq(' ')
    end

    it 'should return string when string' do
      expect(LogFormatter.NA_when_empty('abc')).to eq('abc')
    end

    it 'should return integer when integer' do
      expect(LogFormatter.NA_when_empty(123)).to eq(123)
    end
  end

  context 'format id' do
    it 'should replace empty id with n/a' do
      expect(LogFormatter.format_id(nil)).to eq 'n/a  '
    end
    it 'should replace white space with n/a' do
      expect(LogFormatter.format_id('')).to eq 'n/a  '
      expect(LogFormatter.format_id('  ')).to eq 'n/a  '
    end
    it 'should format number as zero filled value' do
      expect(LogFormatter.format_id(123)).to eq '00123'
    end
    it 'should format number long number to lowest five digits' do
      expect(LogFormatter.format_id(1234567)).to eq '34567'
    end
    it 'should return undersized strings to max length' do
      expect(LogFormatter.format_id('abc')).to eq 'abc  '
    end
    it 'should truncate long strings to max length' do
      expect(LogFormatter.format_id('abcdefg')).to eq 'cdefg'
    end
    it 'should return non-string non-integer as string max length' do
      expect(LogFormatter.format_id(123.456)).to eq '3.456'
    end
  end

  context 'format guid' do
    it 'should format non-blank guid' do
      expect(LogFormatter.format_guid('xyz').size).to eq(38)
    end

    it 'should return n/a when empty' do
      expect(LogFormatter.format_guid(nil).strip).to eq 'n/a'
    end

    it 'should truncate at 38 characters' do
      expect(LogFormatter.format_guid(
        '1234567890123456789012345678901234567890'
      ).size).to eq(38)
    end
  end

  context 'format name' do
    it 'should format non-blank name' do
      expect(LogFormatter.format_name('xyz').size).to eq(30)
    end

    it 'should return n/a when empty' do
      expect(LogFormatter.format_name(nil).strip).to eq 'n/a'
    end

    it 'should truncate at 50 characters' do
      expect(LogFormatter.format_name(
        '123456789012345678901234567890123456789012345678901234567890'
      ).size).to eq(30)
    end
  end

end