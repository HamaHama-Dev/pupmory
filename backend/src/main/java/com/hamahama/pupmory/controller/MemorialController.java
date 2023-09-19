package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.domain.memorial.Comment;
import com.hamahama.pupmory.domain.memorial.UserLike;
import com.hamahama.pupmory.domain.memorial.Post;
import com.hamahama.pupmory.dto.memorial.CommentRequestDto;
import com.hamahama.pupmory.dto.memorial.PostRequestDto;
import com.hamahama.pupmory.service.MemorialService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

/**
 * @author Queue-ri
 * @since 2023/09/11
 */

@RequiredArgsConstructor
@RestController
@RequestMapping("memorial")
public class MemorialController {
    private final MemorialService memorialService;

    @RequestMapping(method=RequestMethod.POST)
    public void savePost(@RequestHeader(value="Authorization") String uid, @RequestBody PostRequestDto dto) {
        memorialService.savePost(uid, dto);
    }

    @RequestMapping(method=RequestMethod.GET)
    public Optional<Post> getPost(@RequestHeader(value="Authorization") String uid, @RequestParam Long postId) {
        return memorialService.getPost(postId);
    }

    @GetMapping("/like")
    public Optional<UserLike> getLike(@RequestHeader(value="Authorization") String uid, @RequestParam Long postId) {
        return memorialService.getLike(uid, postId);
    }

    @PostMapping("/like")
    public void saveLike(@RequestHeader(value="Authorization") String uid, @RequestParam Long postId) {
        memorialService.saveLike(uid, postId);
    }

    @GetMapping("/comment")
    public List<Comment> getComment(@RequestParam Long postId) {
        return memorialService.getComment(postId);
    }

    @PostMapping("/comment")
    public void saveComment(@RequestHeader(value="Authorization") String uid, @RequestParam Long postId, @RequestBody CommentRequestDto dto) {
        memorialService.saveComment(uid, postId, dto);
    }
}
