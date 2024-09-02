package com.example.t3

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.children
import com.example.t3.databinding.ActivityGameBinding
import nl.dionsegijn.konfetti.core.Party
import nl.dionsegijn.konfetti.core.Position
import nl.dionsegijn.konfetti.core.emitter.Emitter
import java.util.concurrent.TimeUnit

class GameActivity : AppCompatActivity(), View.OnClickListener {
    lateinit var binding: ActivityGameBinding

    private var gameModel: GameModel? = null

    private var party: Party? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        binding = ActivityGameBinding.inflate(layoutInflater)
        setContentView(binding.root)

        party = Party(
            speed = 0f,
            maxSpeed = 30f,
            damping = 0.9f,
            spread = 360,
            colors = listOf(0xfce18a, 0xff726d, 0xf4306d, 0xb48def),
            position = Position.Relative(0.5, 0.3),
            emitter = Emitter(duration = 100, TimeUnit.MILLISECONDS).max(100)
        )
        initializeGameGrid()

        binding.startGameBtn.setOnClickListener { startGame() }

        GameData.gameModel.observe(this) {
            gameModel = it
            setUI()
        }
    }

    fun setUI() {
        println("setUI.fired")
        gameModel?.apply {
            var pos = 0
            for (btn in binding.gameGrid.children.iterator()) {
                (btn as Button).text = filledPos[pos]
                btn.tag = pos
                pos++
            }

            binding.startGameBtn.visibility = View.VISIBLE

            binding.gameStatusText.text = when (gameStatus) {
                GameStatus.CREATED -> {
                    binding.startGameBtn.visibility = View.INVISIBLE
                    "Game ID: $gameId"
                }

                GameStatus.JOINED -> {
                    "Click on start game"
                }

                GameStatus.INPROGRESS -> {
                    binding.startGameBtn.visibility = View.INVISIBLE
                    "$currentPlayer turn"
                }

                GameStatus.FINISHED -> {
                    if (winner.isNotEmpty()) {
                        party?.let { binding.konfettiView.start(it) }
                        "$winner  Won"
                    } else "Draw"
                }

            }
        }


    }

    fun initializeGameGrid() {
        for (i in 1..9) {
            val button =
                LayoutInflater.from(this)
                    .inflate(R.layout.button, binding.gameGrid, false) as Button
            button.id = i // Set unique ID
            button.text = "-" // Set button text
            button.setOnClickListener(this)
            binding.gameGrid.addView(button)

        }

    }

    fun startGame() {
        gameModel?.apply {
            GameData.saveGameModel(GameModel(gameStatus = GameStatus.INPROGRESS, gameId = gameId))
        }
    }

    fun checkForWinner() {
        val winningPos = arrayOf(
            intArrayOf(0, 1, 2),
            intArrayOf(3, 4, 5),
            intArrayOf(6, 7, 8),
            intArrayOf(0, 3, 6),
            intArrayOf(1, 4, 7),
            intArrayOf(2, 5, 8),
            intArrayOf(0, 4, 8),
            intArrayOf(2, 4, 6),
        )

        gameModel?.apply {
            for (i in winningPos) {
                //012
                if (
                    filledPos[i[0]] == filledPos[i[1]] &&
                    filledPos[i[1]] == filledPos[i[2]] &&
                    filledPos[i[0]].isNotEmpty()
                ) {
                    gameStatus = GameStatus.FINISHED
                    winner = filledPos[i[0]]
                }
            }

            if (filledPos.none { it.isEmpty() }) {
                gameStatus = GameStatus.FINISHED
            }


            GameData.saveGameModel(this)

        }
    }

    override fun onClick(v: View?) {
        println("button clicked: ${v?.id}")
        val pos = (v?.tag as Int)
        gameModel?.apply {

            if (gameStatus != GameStatus.INPROGRESS) {
                Toast.makeText(applicationContext, "Game not started", Toast.LENGTH_SHORT).show()
                return;
            }

            if (filledPos[pos].isEmpty()) {
                filledPos[pos] = currentPlayer
                currentPlayer = if (currentPlayer == "X") "O" else "X"
                checkForWinner()

            }

            if (filledPos.none { it.isEmpty() }) {
                gameStatus = GameStatus.FINISHED
            }

            GameData.saveGameModel(this)
        }

    }
}