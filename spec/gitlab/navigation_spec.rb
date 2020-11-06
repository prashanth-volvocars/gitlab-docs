require 'spec_helper'
require 'nanoc'
require 'gitlab/navigation'
require 'gitlab/navigation/section'

describe Gitlab::Navigation do
  subject(:navigation) { described_class.new(items, item) }
  let(:item) { double(path: '/omnibus/user/README.html', identifier: double(to_s: '/omnibus/user/README.md')) }
  let(:items) do
    {
      '/_data/omnibus-nav.yaml' => { sections: [Gitlab::Navigation::Section.new(section_title: 'Omnibus Section')] },
      '/_data/default-nav.yaml' => { sections: [Gitlab::Navigation::Section.new(section_title: 'Default Section')] }
    }
  end

  describe '#nav_items' do
    subject { navigation.nav_items }

    it 'returns project specific sections' do
      sections = subject[:sections]
      section = sections.first

      expect(section.title).to eq('Omnibus Section')
    end

    context 'when yaml configuration for project does not exist' do
      let(:item) { double(path: '/ee/user/README.html', identifier: double(to_s: '/ee/user/README.md')) }

      it 'returns default sections' do
        sections = subject[:sections]
        section = sections.first

        expect(section.title).to eq('Default Section')
      end
    end
  end

  describe '#element_href' do
    subject { navigation.element_href(element) }
    let(:element) { Gitlab::Navigation::Section.new(section_url: url) }
    let(:url) { 'user/README.html' }

    it { is_expected.to eq('/omnibus/user/README.html') }

    context 'when yaml configuration for project does not exist' do
      let(:item) { double(path: '/ee/user/README.html', identifier: double(to_s: '/ee/user/README.md')) }

      it { is_expected.to eq('/ee/user/README.html') }
    end
  end

  describe '#show_element?' do
    subject { navigation.show_element?(element) }
    let(:element) { Gitlab::Navigation::Section.new(section_url: url) }
    let(:url) { 'user/README.html' }

    it { is_expected.to be_truthy }

    context 'when url does not match item path' do
      let(:url) { 'project/README.html' }

      it { is_expected.to be_falsey }
    end
  end

  describe '#id_for' do
    subject { navigation.id_for(element) }
    let(:element) { Gitlab::Navigation::Section.new(section_title: 'Section Example') }

    it { is_expected.to eq 'SectionExample' }
  end

  describe '#optional_ee_badge' do
    subject { navigation.optional_ee_badge(element) }
    let(:element) { Gitlab::Navigation::Section.new(ee_only: ee_only, ee_tier: ee_tier) }
    let(:ee_tier) { 'GitLab Starter' }
    let(:ee_only) { true }

    it { is_expected.to include('span').and include(ee_tier) }

    context 'when ee_only -> false' do
      let(:ee_only) { false }

      it { is_expected.to be_nil }
    end
  end
end
