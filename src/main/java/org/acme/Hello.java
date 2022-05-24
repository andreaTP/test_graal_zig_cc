package org.acme;

import io.quarkus.runtime.annotations.QuarkusMain;

// TODO: check why picocli application fails to start
@QuarkusMain
public class Hello {

    public static void main(String[] args) {
        System.out.printf("Hello world!\n");
    }

}
