package com.api.domain.carte;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "Note")
@Data
public class Note{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
}