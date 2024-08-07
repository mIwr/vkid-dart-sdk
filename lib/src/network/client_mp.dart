//Multi-platform support
export '../network/client.dart'//Stub (web + io without cert validator)
  if (dart.library.io) '../network/client_io.dart';//io with cert validator