
def can_build(platform):
    return True


def configure(env):
    if env['platform'] == "osx":
        env.Append(CPPPATH=['/usr/local/include'])
        env.Append(LIBPATH=['/usr/local/lib'])
        env.Append(LINKFLAGS=['-lavformat', '-lavcodec'])