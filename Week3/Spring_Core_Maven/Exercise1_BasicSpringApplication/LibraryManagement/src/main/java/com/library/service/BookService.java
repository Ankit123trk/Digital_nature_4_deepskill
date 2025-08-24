package com.library.service;

import com.library.repository.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;

public class BookService {

    public void displayBookInfo() {
        BookRepository bookRepository = new BookRepository();
        String bookData = bookRepository.getBookData();
        System.out.println("Sample Book Data : \n" + bookData);
    }
}
