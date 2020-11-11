require 'spec_helper'
require 'gitlab/navigation/doc'

describe Gitlab::Navigation::Doc do
  subject(:doc) { described_class.new(element) }
  let(:element) do
    {
      doc_title: title,
      external_url: external_url,
      doc_url: url,
      ee_only: ee_only,
      ee_tier: ee_tier
    }
  end
  let(:title) { 'Title' }
  let(:external_url) { 'http://example.com' }
  let(:url) { 'README.html' }
  let(:ee_only) { true }
  let(:ee_tier) { 'GitLab Premium' }

  describe '#title' do
    subject { doc.title }

    it { is_expected.to eq(title) }
  end

  describe '#external_url' do
    subject { doc.external_url }

    it { is_expected.to eq(external_url) }
  end

  describe '#url' do
    subject { doc.url }

    it { is_expected.to eq(url) }
  end

  describe '#ee_only?' do
    subject { doc.ee_only? }

    it { is_expected.to eq(ee_only) }
  end

  describe '#ee_tier' do
    subject { doc.ee_tier }

    it { is_expected.to eq(ee_tier) }
  end

  describe '#children' do
    subject { doc.children }

    it { is_expected.to eq([]) }
  end
end
