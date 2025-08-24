package com.example.mockito;

import com.example.mockito.mockito.ExternalApi;
import com.example.mockito.mockito.MyService;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class MyServiceTest {

    @Test
    public void testVerifyInteraction(){

        ExternalApi mockApi = mock(ExternalApi.class);

        when(mockApi.getData()).thenReturn("Mock Data");

        MyService service = new MyService(mockApi);

        String result = service.fetchData();

        assertEquals("Mock Data", result);
    }

}
