require './lib/caesar_cipher'

describe '#caesar_cipher' do
  it 'returns cipher with normal values' do
    expect(caesar_cipher('abcd', 2)).to eql('cdef')
  end

  it 'returns cipher with overflowed offset' do
    expect(caesar_cipher('abcd', 36)).to eql('klmn')
  end

  it 'returns cipher with special characters unaffected' do
    expect(caesar_cipher('&lm7no%', 28)).to eql('&no7pq%')
  end

  it 'maintains capitalization' do
    expect((caesar_cipher('Hello World!', 8))).to eql('Pmttw Ewztl!')
  end
end
