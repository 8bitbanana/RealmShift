
export class DialogManager
    new: () =>
        @reset!

    reset: () =>
        @queue = {}
        @running = false
        @awaitinginput = false

    push: (dialog) => -- Add a new dialog to the end of the queue
        table.insert(@queue, dialog)
        if not @running
            @queue[1]\begin!
            @running = true

    advanceInput: () =>
        if @queue[1] != nil
            @queue[1]\advanceInput!

    update: () =>
        if @queue[1] != nil
            @queue[1]\update!
            @awaitinginput = @queue[1].awaitinginput
            if @queue[1].done
                table.remove(@queue, 1)
                Push\setCanvas("dialogbox")
                lg.clear()
                Push\setCanvas("main")
                if @queue[1] == nil
                    @running = false
                else
                    @queue[1]\begin!

    draw: () =>
        if @queue[1] != nil
            @queue[1]\draw!