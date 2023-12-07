
#include "base/logging.h"


#define NOG                                                            \
  logging::LogMessage(__FILE__, __LINE__, logging::LOG_ERROR).stream() \
      << "\n\nNaeem Log: " << __FUNCTION__ << "\n"
