class GzipFilter < Nanoc::Filter
  identifier :gzip

  def run(content, params = {})
    output = StringIO.new

    gzip = Zlib::GzipWriter.new(output, Zlib::BEST_COMPRESSION)
    gzip.write(content)
    gzip.close

    output.string
  end
end
