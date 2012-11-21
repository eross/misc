//
//  javaversion.java
//  javaversion
//
//  Created by Eric Ross on 1/13/06.
//  Copyright (c) 2006 __MyCompanyName__. All rights reserved.
//
import java.util.*;

public class javaversion {

    public static void main (String args[]) {
        String javaVersion = System.getProperty("java.version");
        System.out.println("Java Version:  "+javaVersion);
    }
}
