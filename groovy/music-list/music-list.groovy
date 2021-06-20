@Grab('com.fasterxml.jackson.core:jackson-core:2.12.3')
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.DeserializationFeature
import groovy.transform.ToString
import groovy.json.JsonOutput
import groovy.json.JsonSlurper

@ToString
class SongEntry {
  String artist

  String track

  String album

  Integer year
}

void process() {
  String json = """
  { "artist": "Tom Petty", "track": "It's Good To Be King", "album": "It's Good To Be King", "year": 1994 }
  """
  // ObjectMapper mapper = new ObjectMapper().configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
  ObjectMapper mapper = new ObjectMapper()
  // mapper.configure(DeserializationConfig.Feature.FAIL_ON_UNKNOWN_PROPERTIES, false);
  // mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
  SongEntry songEntry = mapper.readValue(json, SongEntry.class)
  println songEntry
}


process()

// def main() {
//   // File file = new File('tom_petty_its_good_to_be_king.json')
//   String json = """
//   { "artist": "Tom Petty", "track": "It's Good To Be King", "album": "It's Good To Be King", "year": 1994 }
//   """
//   process()
// }

// main()
