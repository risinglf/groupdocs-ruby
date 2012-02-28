module GroupDocs
  module Errors

    class NoClientIdError         < StandardError ; end
    class NoPrivateKeyError       < StandardError ; end
    class UnsupportedMethodError  < StandardError ; end
    class IncorrectResponseStatus < StandardError ; end

  end # Errors
end # GroupDocs
