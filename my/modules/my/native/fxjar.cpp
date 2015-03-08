#include <myfxjar.gen.h>

#include <myavn/embeddedres.h>
namespace
{
  myavn::embeddedres myfxjar_(sizeof(myfxjararr), myfxjararr);
}
void *myfxjarres = (void*)&myfxjar_;

