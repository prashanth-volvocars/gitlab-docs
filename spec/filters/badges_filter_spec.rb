require 'spec_helper'
require 'nanoc'
require 'filters/badges'

describe BadgesFilter do
  subject { described_class.new }

  describe '#run_from_markdown' do
    context 'when **(FREE)** badge' do
      it 'returns correct HTML' do
        content = '**(FREE)**'
        expect(subject.run_from_markdown(content)).to eq('<span class="badge-trigger free"></span>')
      end
    end

    context 'when **(PREMIUM)** badge' do
      it 'returns correct HTML' do
        content = '**(PREMIUM)**'
        expect(subject.run_from_markdown(content)).to eq('<span class="badge-trigger premium"></span>')
      end
    end

    context 'when **(ULTIMATE)** badge' do
      it 'returns correct HTML' do
        content = '**(ULTIMATE)**'
        expect(subject.run_from_markdown(content)).to eq('<span class="badge-trigger ultimate"></span>')
      end
    end

    context 'when **(FREE SELF)** badge' do
      it 'returns correct HTML' do
        content = '**(FREE SELF)**'
        expect(subject.run_from_markdown(content)).to eq('<span class="badge-trigger free-self"></span>')
      end
    end

    context 'when **(PREMIUM SELF)** badge' do
      it 'returns correct HTML' do
        content = '**(PREMIUM SELF)**'
        expect(subject.run_from_markdown(content)).to eq('<span class="badge-trigger premium-self"></span>')
      end
    end

    context 'when **(ULTIMATE SELF)** badge' do
      it 'returns correct HTML' do
        content = '**(ULTIMATE SELF)**'
        expect(subject.run_from_markdown(content)).to eq('<span class="badge-trigger ultimate-self"></span>')
      end
    end

    context 'when **(FREE SAAS)** badge' do
      it 'returns correct HTML' do
        content = '**(FREE SAAS)**'
        expect(subject.run_from_markdown(content)).to eq('<span class="badge-trigger free-saas"></span>')
      end
    end

    context 'when **(PREMIUM SAAS)** badge' do
      it 'returns correct HTML' do
        content = '**(PREMIUM SAAS)**'
        expect(subject.run_from_markdown(content)).to eq('<span class="badge-trigger premium-saas"></span>')
      end
    end

    context 'when **(ULTIMATE SAAS)** badge' do
      it 'returns correct HTML' do
        content = '**(ULTIMATE SAAS)**'
        expect(subject.run_from_markdown(content)).to eq('<span class="badge-trigger ultimate-saas"></span>')
      end
    end
  end
end
