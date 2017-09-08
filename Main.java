import com.mongodb.AggregationOutput;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MapReduceCommand;
import com.mongodb.MapReduceOutput;
import com.mongodb.MongoClient;
import com.mongodb.ServerAddress;
import org.bson.*;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.Iterator;

import static java.util.concurrent.TimeUnit.SECONDS;



public class Main {

    public static void main(String[] args) {
        try {
            MongoClient client = new MongoClient("127.0.0.1", 27017);
            DB db = client.getDB("prac6db");
            DBCollection coll = db.getCollection("facebook");
            
            System.out.println("Database Collections:");
            Set<String> s = db.getCollectionNames();
            for (Iterator<String> k = s.iterator(); k.hasNext();) {
                System.out.println(k.next());
            }
            System.out.println();
            
            DBCursor c = coll.find();
            
            System.out.println("facebook collection:");
            try {
                while (c.hasNext()) {
                    System.out.println(c.next());
                }
            } finally {
                c.close();
            }
            System.out.println();
            
            Iterable<DBObject> a = 
                    coll.aggregate(
                        (DBObject) new BasicDBObject("$unwind", "$data"),
                        (DBObject) new BasicDBObject("$project", 
                            new BasicDBObject("message", "$data.message")
                        )
                    ).results();
            
            System.out.println("Messages:");
            for (Iterator<DBObject> j = a.iterator(); j.hasNext();) {
                System.out.println(j.next());
            }
            
            MapReduceOutput out = coll.mapReduce(new MapReduceCommand(
                coll, 
                "function() {emit(this.data.from, this.data.message)}",
                null,
                "{out: \"messages\"}",
                MapReduceCommand.OutputType.INLINE,
                null));
            for (DBObject d : out.results()) {
                System.out.println(d);
            }
            
           
        } catch (Exception e) { }
    }
    
}
