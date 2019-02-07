require 'spec_helper'

require 'nokogiri'
require 'gitlab/docs/page'
require 'gitlab/docs/link'
require 'gitlab/docs/element'
require 'gitlab/docs/document'

describe Gitlab::Docs::Page do
  subject do
    described_class.new('some/file.html')
  end

  context 'when file exists' do
    before do
      allow(File).to receive(:exists?)
        .with('some/file.html')
        .and_return(true)

      allow(File).to receive(:read)
        .with('some/file.html')
        .and_return <<~HTML
          <html>
            <body>
              <a href="../link.html#my-anchor">See external file</a>
              <a href="#internal-anchor">See internal section</a>
              <a href="#internal-anchor-2">See internal section broken</a>

              <h1 id="internal-anchor">Some section</h1>
            </body
          </html>
        HTML
    end

    describe '#links' do
      it 'collects links on a page' do
        expect(subject.links.count).to eq 3
      end
    end

    describe '#hrefs' do
      it 'collects all hrefs' do
        expect(subject.hrefs).to match_array %w[../link.html#my-anchor
                                                #internal-anchor
                                                #internal-anchor-2]
      end
    end

    describe '#ids' do
      it 'collects all ids' do
        expect(subject.ids).to match_array %w[internal-anchor]
      end
    end

    describe '#has_anchor?' do
      it 'returns true when anchor exists on a page' do
        expect(subject.has_anchor?('internal-anchor')).to be true
      end

      it 'returns false when anchors does not exist' do
        expect(subject.has_anchor?('internal-anchor-2')).to be false
      end
    end
  end

  describe '#directory' do
    it 'returns base directory of a file' do
      expect(subject.directory).to eq 'some'
    end
  end

  describe '.build' do
    context 'when path does not lead to the HTML file' do
      it 'builds an index.html page object' do
        page = described_class.build('some/path')

        expect(page.file).to eq 'some/path/index.html'
      end
    end

    context 'when path leads to the HTML file' do
      it 'builds an object representing that file' do
        page = described_class.build('some/path/file.html')

        expect(page.file).to eq 'some/path/file.html'
      end
    end
  end
end
